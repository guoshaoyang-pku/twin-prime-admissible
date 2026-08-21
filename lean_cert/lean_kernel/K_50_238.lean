import Sound
import lean_certs.cert_50_238

open CertVerify

set_option maxHeartbeats 20000000 in
theorem H50_gt_238_kernel : ¬ ∃ t : List Nat, admissible 50 t = true ∧ diameter t ≤ 238 := by
  exact certValidRoot_sound (k := 50) (d := 238) (c := cert_50_238) (by decide)
