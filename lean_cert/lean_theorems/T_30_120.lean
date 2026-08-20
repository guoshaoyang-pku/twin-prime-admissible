import Sound
import lean_certs.cert_30_120

open CertVerify

theorem H30_gt_120 : ¬ ∃ t : List Nat, admissible 30 t = true ∧ diameter t ≤ 120 := by
  exact certValidRoot_sound (k := 30) (d := 120) (c := cert_30_120) (by native_decide)
