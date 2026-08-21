import Sound
import lean_certs.cert_40_92

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H40_gt_92_kernel : ¬ ∃ t : List Nat, admissible 40 t = true ∧ diameter t ≤ 92 := by
  exact certValidRoot_sound (k := 40) (d := 92) (c := cert_40_92) (by decide)
