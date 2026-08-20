import Sound
import lean_certs.cert_49_188

open CertVerify

theorem H49_gt_188 : ¬ ∃ t : List Nat, admissible 49 t = true ∧ diameter t ≤ 188 := by
  exact certValidRoot_sound (k := 49) (d := 188) (c := cert_49_188) (by native_decide)
