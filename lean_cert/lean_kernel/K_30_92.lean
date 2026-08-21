import Sound
import lean_certs.cert_30_92

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H30_gt_92_kernel : ¬ ∃ t : List Nat, admissible 30 t = true ∧ diameter t ≤ 92 := by
  exact certValidRoot_sound (k := 30) (d := 92) (c := cert_30_92) (by decide)
