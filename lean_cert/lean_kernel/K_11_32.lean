import Sound
import lean_certs.cert_11_32

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H11_gt_32_kernel : ¬ ∃ t : List Nat, admissible 11 t = true ∧ diameter t ≤ 32 := by
  exact certValidRoot_sound (k := 11) (d := 32) (c := cert_11_32) (by decide)
