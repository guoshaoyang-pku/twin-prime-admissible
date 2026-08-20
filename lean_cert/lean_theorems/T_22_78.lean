import Sound
import lean_certs.cert_22_78

open CertVerify

theorem H22_gt_78 : ¬ ∃ t : List Nat, admissible 22 t = true ∧ diameter t ≤ 78 := by
  exact certValidRoot_sound (k := 22) (d := 78) (c := cert_22_78) (by native_decide)
