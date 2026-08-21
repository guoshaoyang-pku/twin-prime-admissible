import Sound
import lean_certs.cert_32_92

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H32_gt_92_kernel : ¬ ∃ t : List Nat, admissible 32 t = true ∧ diameter t ≤ 92 := by
  exact certValidRoot_sound (k := 32) (d := 92) (c := cert_32_92) (by decide)
