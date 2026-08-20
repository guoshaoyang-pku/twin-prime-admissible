import Sound
import lean_certs.cert_38_92

open CertVerify

theorem H38_gt_92 : ¬ ∃ t : List Nat, admissible 38 t = true ∧ diameter t ≤ 92 := by
  exact certValidRoot_sound (k := 38) (d := 92) (c := cert_38_92) (by native_decide)
