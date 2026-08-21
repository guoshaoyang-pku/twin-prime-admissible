import Sound
import lean_certs.cert_46_92

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H46_gt_92_kernel : ¬ ∃ t : List Nat, admissible 46 t = true ∧ diameter t ≤ 92 := by
  exact certValidRoot_sound (k := 46) (d := 92) (c := cert_46_92) (by decide)
