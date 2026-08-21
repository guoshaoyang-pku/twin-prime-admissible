import Sound
import lean_certs.cert_32_86

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H32_gt_86_kernel : ¬ ∃ t : List Nat, admissible 32 t = true ∧ diameter t ≤ 86 := by
  exact certValidRoot_sound (k := 32) (d := 86) (c := cert_32_86) (by decide)
