import Sound
import lean_certs.cert_41_92

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H41_gt_92_kernel : ¬ ∃ t : List Nat, admissible 41 t = true ∧ diameter t ≤ 92 := by
  exact certValidRoot_sound (k := 41) (d := 92) (c := cert_41_92) (by decide)
