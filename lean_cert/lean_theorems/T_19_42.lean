import Sound
import lean_certs.cert_19_42

open CertVerify

theorem H19_gt_42 : ¬ ∃ t : List Nat, admissible 19 t = true ∧ diameter t ≤ 42 := by
  exact certValidRoot_sound (k := 19) (d := 42) (c := cert_19_42) (by native_decide)
