import Sound
import lean_certs.cert_31_62

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H31_gt_62_kernel : ¬ ∃ t : List Nat, admissible 31 t = true ∧ diameter t ≤ 62 := by
  exact certValidRoot_sound (k := 31) (d := 62) (c := cert_31_62) (by decide)
