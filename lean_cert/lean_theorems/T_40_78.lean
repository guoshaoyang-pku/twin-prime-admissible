import Sound
import lean_certs.cert_40_78

open CertVerify

theorem H40_gt_78 : ¬ ∃ t : List Nat, admissible 40 t = true ∧ diameter t ≤ 78 := by
  exact certValidRoot_sound (k := 40) (d := 78) (c := cert_40_78) (by native_decide)
