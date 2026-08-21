import Sound
import lean_certs.cert_15_32

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H15_gt_32_kernel : ¬ ∃ t : List Nat, admissible 15 t = true ∧ diameter t ≤ 32 := by
  exact certValidRoot_sound (k := 15) (d := 32) (c := cert_15_32) (by decide)
