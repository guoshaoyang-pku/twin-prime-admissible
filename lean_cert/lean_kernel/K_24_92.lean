import Sound
import lean_certs.cert_24_92

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H24_gt_92_kernel : ¬ ∃ t : List Nat, admissible 24 t = true ∧ diameter t ≤ 92 := by
  exact certValidRoot_sound (k := 24) (d := 92) (c := cert_24_92) (by decide)
