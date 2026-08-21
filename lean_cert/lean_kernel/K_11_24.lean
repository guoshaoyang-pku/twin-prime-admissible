import Sound
import lean_certs.cert_11_24

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H11_gt_24_kernel : ¬ ∃ t : List Nat, admissible 11 t = true ∧ diameter t ≤ 24 := by
  exact certValidRoot_sound (k := 11) (d := 24) (c := cert_11_24) (by decide)
