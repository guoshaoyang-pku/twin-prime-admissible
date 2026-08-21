import Sound
import lean_certs.cert_32_118

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H32_gt_118_kernel : ¬ ∃ t : List Nat, admissible 32 t = true ∧ diameter t ≤ 118 := by
  exact certValidRoot_sound (k := 32) (d := 118) (c := cert_32_118) (by decide)
