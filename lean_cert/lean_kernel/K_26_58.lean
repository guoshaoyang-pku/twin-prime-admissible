import Sound
import lean_certs.cert_26_58

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H26_gt_58_kernel : ¬ ∃ t : List Nat, admissible 26 t = true ∧ diameter t ≤ 58 := by
  exact certValidRoot_sound (k := 26) (d := 58) (c := cert_26_58) (by decide)
