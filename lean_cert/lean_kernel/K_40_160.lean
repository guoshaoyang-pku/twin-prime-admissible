import Sound
import lean_certs.cert_40_160

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H40_gt_160_kernel : ¬ ∃ t : List Nat, admissible 40 t = true ∧ diameter t ≤ 160 := by
  exact certValidRoot_sound (k := 40) (d := 160) (c := cert_40_160) (by decide)
