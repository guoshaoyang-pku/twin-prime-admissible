import Sound
import lean_certs.cert_32_124

open CertVerify

theorem H32_gt_124 : ¬ ∃ t : List Nat, admissible 32 t = true ∧ diameter t ≤ 124 := by
  exact certValidRoot_sound (k := 32) (d := 124) (c := cert_32_124) (by native_decide)
