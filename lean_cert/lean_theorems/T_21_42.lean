import Sound
import lean_certs.cert_21_42

open CertVerify

theorem H21_gt_42 : ¬ ∃ t : List Nat, admissible 21 t = true ∧ diameter t ≤ 42 := by
  exact certValidRoot_sound (k := 21) (d := 42) (c := cert_21_42) (by native_decide)
