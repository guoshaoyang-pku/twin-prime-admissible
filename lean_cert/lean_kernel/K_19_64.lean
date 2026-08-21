import Sound
import lean_certs.cert_19_64

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H19_gt_64_kernel : ¬ ∃ t : List Nat, admissible 19 t = true ∧ diameter t ≤ 64 := by
  exact certValidRoot_sound (k := 19) (d := 64) (c := cert_19_64) (by decide)
