import Sound
import lean_certs.cert_25_78

open CertVerify

theorem H25_gt_78 : ¬ ∃ t : List Nat, admissible 25 t = true ∧ diameter t ≤ 78 := by
  exact certValidRoot_sound (k := 25) (d := 78) (c := cert_25_78) (by native_decide)
