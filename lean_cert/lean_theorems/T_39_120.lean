import Sound
import lean_certs.cert_39_120

open CertVerify

theorem H39_gt_120 : ¬ ∃ t : List Nat, admissible 39 t = true ∧ diameter t ≤ 120 := by
  exact certValidRoot_sound (k := 39) (d := 120) (c := cert_39_120) (by native_decide)
