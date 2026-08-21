import Sound
import lean_certs.cert_36_92

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H36_gt_92_kernel : ¬ ∃ t : List Nat, admissible 36 t = true ∧ diameter t ≤ 92 := by
  exact certValidRoot_sound (k := 36) (d := 92) (c := cert_36_92) (by decide)
