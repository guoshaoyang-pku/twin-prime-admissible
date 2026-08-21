import Sound
import lean_certs.cert_15_42

open CertVerify

theorem H15_gt_42 : ¬ ∃ t : List Nat, admissible 15 t = true ∧ diameter t ≤ 42 := by
  exact certValidRoot_sound (k := 15) (d := 42) (c := cert_15_42) (by native_decide)
