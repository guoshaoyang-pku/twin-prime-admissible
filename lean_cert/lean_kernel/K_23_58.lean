import Sound
import lean_certs.cert_23_58

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H23_gt_58_kernel : ¬ ∃ t : List Nat, admissible 23 t = true ∧ diameter t ≤ 58 := by
  exact certValidRoot_sound (k := 23) (d := 58) (c := cert_23_58) (by decide)
