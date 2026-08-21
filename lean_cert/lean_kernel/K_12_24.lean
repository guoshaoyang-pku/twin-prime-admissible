import Sound
import lean_certs.cert_12_24

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H12_gt_24_kernel : ¬ ∃ t : List Nat, admissible 12 t = true ∧ diameter t ≤ 24 := by
  exact certValidRoot_sound (k := 12) (d := 24) (c := cert_12_24) (by decide)
