import Sound
import lean_certs.cert_21_58

open CertVerify

theorem H21_gt_58 : ¬ ∃ t : List Nat, admissible 21 t = true ∧ diameter t ≤ 58 := by
  exact certValidRoot_sound (k := 21) (d := 58) (c := cert_21_58) (by native_decide)
