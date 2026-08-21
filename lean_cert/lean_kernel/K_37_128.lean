import Sound
import lean_certs.cert_37_128

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H37_gt_128_kernel : ¬ ∃ t : List Nat, admissible 37 t = true ∧ diameter t ≤ 128 := by
  exact certValidRoot_sound (k := 37) (d := 128) (c := cert_37_128) (by decide)
