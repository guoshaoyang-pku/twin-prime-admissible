import Sound
import lean_certs.cert_28_92

open CertVerify

theorem H28_gt_92 : ¬ ∃ t : List Nat, admissible 28 t = true ∧ diameter t ≤ 92 := by
  exact certValidRoot_sound (k := 28) (d := 92) (c := cert_28_92) (by native_decide)
