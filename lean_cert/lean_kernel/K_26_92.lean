import Sound
import lean_certs.cert_26_92

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H26_gt_92_kernel : ¬ ∃ t : List Nat, admissible 26 t = true ∧ diameter t ≤ 92 := by
  exact certValidRoot_sound (k := 26) (d := 92) (c := cert_26_92) (by decide)
