import Sound
import lean_certs.cert_28_120

open CertVerify

theorem H28_gt_120 : ¬ ∃ t : List Nat, admissible 28 t = true ∧ diameter t ≤ 120 := by
  exact certValidRoot_sound (k := 28) (d := 120) (c := cert_28_120) (by native_decide)
