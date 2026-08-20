import Sound
import lean_certs.cert_30_72

open CertVerify

theorem H30_gt_72 : ¬ ∃ t : List Nat, admissible 30 t = true ∧ diameter t ≤ 72 := by
  exact certValidRoot_sound (k := 30) (d := 72) (c := cert_30_72) (by native_decide)
