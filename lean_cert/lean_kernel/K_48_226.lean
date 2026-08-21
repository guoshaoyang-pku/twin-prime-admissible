import Sound
import lean_certs.cert_48_226

open CertVerify

set_option maxHeartbeats 20000000 in
theorem H48_gt_226_kernel : ¬ ∃ t : List Nat, admissible 48 t = true ∧ diameter t ≤ 226 := by
  exact certValidRoot_sound (k := 48) (d := 226) (c := cert_48_226) (by decide)
