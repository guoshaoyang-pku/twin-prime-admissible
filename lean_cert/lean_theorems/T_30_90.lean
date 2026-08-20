import Sound
import lean_certs.cert_30_90

open CertVerify

theorem H30_gt_90 : ¬ ∃ t : List Nat, admissible 30 t = true ∧ diameter t ≤ 90 := by
  exact certValidRoot_sound (k := 30) (d := 90) (c := cert_30_90) (by native_decide)
