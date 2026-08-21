import Sound
import lean_certs.cert_17_32

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H17_gt_32_kernel : ¬ ∃ t : List Nat, admissible 17 t = true ∧ diameter t ≤ 32 := by
  exact certValidRoot_sound (k := 17) (d := 32) (c := cert_17_32) (by decide)
