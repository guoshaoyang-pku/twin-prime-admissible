import Sound
import lean_certs.cert_35_78

open CertVerify

theorem H35_gt_78 : ¬ ∃ t : List Nat, admissible 35 t = true ∧ diameter t ≤ 78 := by
  exact certValidRoot_sound (k := 35) (d := 78) (c := cert_35_78) (by native_decide)
