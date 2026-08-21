import Sound
import lean_certs.cert_23_62

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H23_gt_62_kernel : ¬ ∃ t : List Nat, admissible 23 t = true ∧ diameter t ≤ 62 := by
  exact certValidRoot_sound (k := 23) (d := 62) (c := cert_23_62) (by decide)
