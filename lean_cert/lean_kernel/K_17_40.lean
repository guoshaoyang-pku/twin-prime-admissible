import Sound
import lean_certs.cert_17_40

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H17_gt_40_kernel : ¬ ∃ t : List Nat, admissible 17 t = true ∧ diameter t ≤ 40 := by
  exact certValidRoot_sound (k := 17) (d := 40) (c := cert_17_40) (by decide)
