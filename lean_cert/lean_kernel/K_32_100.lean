import Sound
import lean_certs.cert_32_100

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H32_gt_100_kernel : ¬ ∃ t : List Nat, admissible 32 t = true ∧ diameter t ≤ 100 := by
  exact certValidRoot_sound (k := 32) (d := 100) (c := cert_32_100) (by decide)
