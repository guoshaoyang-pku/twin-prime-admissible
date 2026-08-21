import Sound
import lean_certs.cert_30_104

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H30_gt_104_kernel : ¬ ∃ t : List Nat, admissible 30 t = true ∧ diameter t ≤ 104 := by
  exact certValidRoot_sound (k := 30) (d := 104) (c := cert_30_104) (by decide)
