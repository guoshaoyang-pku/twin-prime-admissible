import Sound
import lean_certs.cert_44_128

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H44_gt_128_kernel : ¬ ∃ t : List Nat, admissible 44 t = true ∧ diameter t ≤ 128 := by
  exact certValidRoot_sound (k := 44) (d := 128) (c := cert_44_128) (by decide)
