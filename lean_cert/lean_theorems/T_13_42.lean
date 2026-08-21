import Sound
import lean_certs.cert_13_42

open CertVerify

theorem H13_gt_42 : ¬ ∃ t : List Nat, admissible 13 t = true ∧ diameter t ≤ 42 := by
  exact certValidRoot_sound (k := 13) (d := 42) (c := cert_13_42) (by native_decide)
