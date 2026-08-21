import Sound
import lean_certs.cert_26_56

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H26_gt_56_kernel : ¬ ∃ t : List Nat, admissible 26 t = true ∧ diameter t ≤ 56 := by
  exact certValidRoot_sound (k := 26) (d := 56) (c := cert_26_56) (by decide)
