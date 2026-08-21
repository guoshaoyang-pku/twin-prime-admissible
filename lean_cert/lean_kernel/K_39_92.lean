import Sound
import lean_certs.cert_39_92

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H39_gt_92_kernel : ¬ ∃ t : List Nat, admissible 39 t = true ∧ diameter t ≤ 92 := by
  exact certValidRoot_sound (k := 39) (d := 92) (c := cert_39_92) (by decide)
