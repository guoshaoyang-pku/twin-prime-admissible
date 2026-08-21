import Sound
import lean_certs.cert_28_104

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H28_gt_104_kernel : ¬ ∃ t : List Nat, admissible 28 t = true ∧ diameter t ≤ 104 := by
  exact certValidRoot_sound (k := 28) (d := 104) (c := cert_28_104) (by decide)
