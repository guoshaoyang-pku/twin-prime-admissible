import Sound
import lean_certs.cert_40_86

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H40_gt_86_kernel : ¬ ∃ t : List Nat, admissible 40 t = true ∧ diameter t ≤ 86 := by
  exact certValidRoot_sound (k := 40) (d := 86) (c := cert_40_86) (by decide)
