import Sound
import lean_certs.cert_48_188

open CertVerify

theorem H48_gt_188 : ¬ ∃ t : List Nat, admissible 48 t = true ∧ diameter t ≤ 188 := by
  exact certValidRoot_sound (k := 48) (d := 188) (c := cert_48_188) (by native_decide)
