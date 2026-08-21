import Sound
import lean_certs.cert_12_32

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H12_gt_32_kernel : ¬ ∃ t : List Nat, admissible 12 t = true ∧ diameter t ≤ 32 := by
  exact certValidRoot_sound (k := 12) (d := 32) (c := cert_12_32) (by decide)
