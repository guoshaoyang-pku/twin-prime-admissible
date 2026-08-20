import Sound
import lean_certs.cert_21_56

open CertVerify

theorem H21_gt_56 : ¬ ∃ t : List Nat, admissible 21 t = true ∧ diameter t ≤ 56 := by
  exact certValidRoot_sound (k := 21) (d := 56) (c := cert_21_56) (by native_decide)
