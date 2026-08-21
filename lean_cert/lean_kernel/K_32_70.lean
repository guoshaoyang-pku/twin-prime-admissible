import Sound
import lean_certs.cert_32_70

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H32_gt_70_kernel : ¬ ∃ t : List Nat, admissible 32 t = true ∧ diameter t ≤ 70 := by
  exact certValidRoot_sound (k := 32) (d := 70) (c := cert_32_70) (by decide)
