import Sound
import lean_certs.cert_39_86

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H39_gt_86_kernel : ¬ ∃ t : List Nat, admissible 39 t = true ∧ diameter t ≤ 86 := by
  exact certValidRoot_sound (k := 39) (d := 86) (c := cert_39_86) (by decide)
