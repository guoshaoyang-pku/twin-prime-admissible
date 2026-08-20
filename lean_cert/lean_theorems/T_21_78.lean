import Sound
import lean_certs.cert_21_78

open CertVerify

theorem H21_gt_78 : ¬ ∃ t : List Nat, admissible 21 t = true ∧ diameter t ≤ 78 := by
  exact certValidRoot_sound (k := 21) (d := 78) (c := cert_21_78) (by native_decide)
